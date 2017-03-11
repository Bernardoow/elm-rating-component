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
    , colorDefault : String
    , colorSelected : String
    , colorOver : String
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
    , colorDefault = "#000000"
    , colorSelected = "#e6e600"
    , colorOver = "#cc6600"
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


{-| Get Color generic basead on params.
-}
getColor : Maybe Int -> Int -> String -> String -> String
getColor rating position color_selected color_default =
    case rating of
        Nothing ->
            color_default

        Just rating ->
            if position <= rating then
                color_selected
            else
                color_default


{-| Check if is over and pass corret params to do func to do work.
-}
is_selected : Model -> Int -> String
is_selected model position =
    if model.isOver then
        getColor model.ratingOver position model.colorOver model.colorDefault
    else
        getColor model.rating position model.colorSelected model.colorDefault


{-| Simple helper function to return list with svgs
-}
viewRating : Model -> List (Html Msg)
viewRating model =
    List.map (\item -> svg_ item <| is_selected model item) <| List.range 1 model.quantity


{-| SVG Item. Future its be settable.
-}
svg_ : Int -> String -> Html Msg
svg_ position color =
    Svg.svg [ onMouseOut MouseOut, onMouseOver <| MouseOver position, onClick <| Click position, attribute "height" "100", attribute "width" "100", attribute "xmlns" "http://www.w3.org/2000/svg", attribute "xmlns:svg" "http://www.w3.org/2000/svg" ]
        [ g []
            [ node "title"
                []
                [ text "star" ]
            , Svg.path [ d "m0,38l37,0l11,-38l11,38l37,0l-30,23l11,38l-30,-23l-30,23l11,-38l-30,-23l0,0z", fill color, id "svg_2", attribute "stroke-dasharray" "null", attribute "stroke-linecap" "null", attribute "stroke-linejoin" "null", attribute "stroke-width" "0" ]
                []
            , text "  "
            ]
        ]


{-| Simple View
-}
view : Model -> Html Msg
view model =
    div [] <| viewRating model
