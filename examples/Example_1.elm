module Basic exposing (Model, Msg(..), initial, main, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Rating exposing (Msg(..))
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onMouseOut, onMouseOver)
import Browser exposing (element)


type Msg
    = RatingMessage Rating.Msg
    | QuantityStarInput String
    | CheckBoxInput Bool


type alias Model =
    { rating : Rating.Model }


view : Model -> Html Msg
view model =
    let
        rating =
            case model.rating.rating of
                Nothing ->
                    Html.text ""

                Just rating_value ->
                    div []
                        [ p [] [ Html.text <| "Your rating is " ++ String.fromInt rating_value ]
                        , p [] [ Html.text <| "Your rating percent is " ++ String.fromFloat model.rating.ratingPercent ++ " %" ]
                        ]
    in
        div []
            [ Html.map RatingMessage (Rating.view model.rating)
            , rating
            , input [ onInput QuantityStarInput, value <| String.fromInt model.rating.quantity ] []
            , br [] []
            , input [ Html.Attributes.type_ "checkbox", onCheck CheckBoxInput ] []
            , Html.text "read only"
            , br [] []
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RatingMessage rating_msg ->
            let
                ( updateRating, subCmd ) =
                    Rating.update rating_msg model.rating
            in
                ( { model | rating = updateRating }
                , Cmd.map RatingMessage subCmd
                )

        QuantityStarInput quantity_str ->
            let
                quantity =
                    String.toInt quantity_str |> Maybe.withDefault 0

                rating =
                    model.rating

                rating_update =
                    { rating | quantity = quantity }
            in
                ( { model | rating = rating_update }
                , Cmd.none
                )

        CheckBoxInput bool ->
            let
                rating =
                    model.rating

                rating_update =
                    { rating | readOnly = bool }
            in
                ( { model | rating = rating_update }
                , Cmd.none
                )


initial : () -> ( Model, Cmd Msg )
initial _ =
    ( Model Rating.defaultModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    element
        { init = initial
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
