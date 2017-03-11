module Basic exposing (..)

import Rating exposing (Msg(..))
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onMouseOver, onMouseOut)


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

                Just rating ->
                    div []
                        [ p [] [ Html.text <| "Your rating is " ++ (toString rating) ]
                        , p [] [ Html.text <| "Your rating percent is " ++ (toString model.rating.ratingPercent) ++ " %" ]
                        ]
    in
        div []
            [ Html.map RatingMessage (Rating.view model.rating)
            , rating
            , input [ onInput QuantityStarInput, value <| toString model.rating.quantity ] []
            , br [] []
            , input [ Html.Attributes.type_ "checkbox", onCheck CheckBoxInput ] []
            , Html.text "read only"
            , br [] []
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RatingMessage msg ->
            let
                ( updateRating, subCmd ) =
                    Rating.update msg model.rating
            in
                { model | rating = updateRating } ! [ Cmd.map RatingMessage subCmd ]

        QuantityStarInput quantity_str ->
            let
                quantity =
                    String.toInt quantity_str |> Result.toMaybe |> Maybe.withDefault 0

                rating =
                    model.rating

                rating_update =
                    { rating | quantity = quantity }
            in
                { model | rating = rating_update } ! []

        CheckBoxInput bool ->
            let
                rating =
                    model.rating

                rating_update =
                    { rating | readOnly = bool }
            in
                { model | rating = rating_update } ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


initial : Model
initial =
    Model Rating.defaultModel


main : Program Never Model Msg
main =
    program
        { init = ( initial, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
