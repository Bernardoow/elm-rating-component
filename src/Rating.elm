module Rating exposing (defaultModel, Msg(..), Model, view, update)

{-| A Rating for Elm

# The exposes
@docs defaultModel, Msg, update, view, Model

-}

import Html exposing (Html, a, button, code, div, input)
import Html.Attributes exposing (attribute, href, value)
import Html.Events exposing (onClick, onInput)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onMouseOver, onMouseOut)


-- MODEL


{-| The type of The Rating.
-}
type alias Model =
    { rating : Maybe Int
    , quantity : Int
    , svgDefault : Svg.Svg Msg
    , svgSelected : Svg.Svg Msg
    , svgOver : Svg.Svg Msg
    , svgParentAtributes : List ( String, String )
    , svgParentClass : List ( String, Bool )
    , ratingPercent : Float
    , isOver : Bool
    , ratingOver : Maybe Int
    , readOnly : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( defaultModel, Cmd.none )


{-| -}
defaultModel : Model
defaultModel =
    { rating = Nothing
    , quantity = 5
    , svgDefault = starDefault
    , svgSelected = starSelected
    , svgOver = starOver
    , svgParentAtributes = [ ( "display", "inline" ) ]
    , svgParentClass = []
    , ratingPercent = 0
    , isOver = False
    , ratingOver = Nothing
    , readOnly = False
    }


{-| The type representing messages that are passed inside the Rating.
-}
type Msg
    = Click Int
    | MouseOver Int
    | MouseOut


{-| Simple Update for the do work.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click position ->
            let
                new_position =
                    case model.rating of
                        Nothing ->
                            position

                        Just position_ ->
                            if position == 1 && position_ == 1 then
                                0
                            else
                                position

                percent =
                    (toFloat new_position) / (toFloat model.quantity) * 100
            in
                if model.readOnly then
                    model ! []
                else
                    { model | rating = Just new_position, ratingPercent = percent } ! []

        MouseOver position ->
            if model.readOnly then
                model ! []
            else
                { model | isOver = True, ratingOver = Just position } ! []

        MouseOut ->
            if model.readOnly then
                model ! []
            else
                { model | isOver = False } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


{-| Check if is over and pass corret params to do func to do work.
-}
is_selected : Model -> Int -> Svg.Svg Msg
is_selected model position =
    if model.isOver then
        model.svgOver
    else
        case model.rating of
            Nothing ->
                model.svgDefault

            Just rating ->
                if position <= rating then
                    model.svgSelected
                else
                    model.svgDefault


{-| Simple helper function to return list with svgs
-}
viewRating : Model -> List (Html Msg)
viewRating model =
    List.map (\item -> svg_parent model item) <| List.range 1 model.quantity


svg_parent : Model -> Int -> Html Msg
svg_parent model position =
    let
        ( selected, over ) =
            case model.rating of
                Nothing ->
                    ( False, False )

                Just rating ->
                    if position <= rating then
                        ( True, model.isOver )
                    else
                        ( False, model.isOver )
    in
        div [ Html.Attributes.attribute "data-selected" <| toString selected, Html.Attributes.attribute "data-over" <| toString over, Html.Attributes.style model.svgParentAtributes, Html.Attributes.classList model.svgParentClass, onMouseOut MouseOut, onMouseOver <| MouseOver position, onClick <| Click position ]
            [ is_selected model position ]


starDefault =
    svg [ class "star rating", attribute "data-rating" "5", attribute "height" "25", attribute "width" "23" ]
        [ node "polygon"
            [ attribute "points" "9.9, 1.1, 3.3, 21.78, 19.8, 8.58, 0, 8.58, 16.5, 21.78", attribute "style" "fill-rule:nonzero;" ]
            []
        , text "  "
        ]


starSelected =
    svg [ class "star rating", attribute "data-rating" "5", attribute "height" "25", fill "#e6e600", attribute "width" "23" ]
        [ node "polygon"
            [ attribute "points" "9.9, 1.1, 3.3, 21.78, 19.8, 8.58, 0, 8.58, 16.5, 21.78", attribute "style" "fill-rule:nonzero;" ]
            []
        , text "  "
        ]


starOver =
    svg [ class "star rating", attribute "data-rating" "5", attribute "height" "25", fill "#cc6600", attribute "width" "23" ]
        [ node "polygon"
            [ attribute "points" "9.9, 1.1, 3.3, 21.78, 19.8, 8.58, 0, 8.58, 16.5, 21.78", attribute "style" "fill-rule:nonzero;" ]
            []
        , text "  "
        ]


{-| Simple View
-}
view : Model -> Html Msg
view model =
    div [] <| viewRating model
