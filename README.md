# elm-rating



A rating component in Elm.


## Usage

The Rating need a Rating Model on your model  like this:

```elm
    type alias Model =
        { rating : Rating.Model }
```

The view will be update based on this rating. Rating expose `defaultModel`.

I recomend only change the variable:  quantity, colorDefault ,colorSelected, colorOver, readOnly.

If need show rating defined, change rating and rating Percent.

Dont Touch isOver, ratingOver.

```elm
initial : Model
initial =
    Model Rating.defaultModel
```

The Rating can be displayed in a view using the Rating.view function. It returns its own message type so you should wrap it in one of your own messages using Html.map:
```elm
type Msg
    = ...
    | RatingMessage Rating.Msg
    | ...
```
```elm
view : Model -> Html Msg
view model =
    ...
    div [] [
            Html.map RatingMessage (Rating.view model.rating)
        ]
```
In order handle `Msg` in your update function, you should unwrap the `Rating.Msg` and pass it
down to the `Rating.update` function. The `Rating.update` function returns the Rating Model updated.

```elm
update : Msg -> Model -> ( Model, Cmd, Msg )
update msg model =
    case msg of
        ...

         RatingMessage msg ->
            let
                ( updateRating, subCmd ) =
                    Rating.update msg model.rating
            in
                { model | rating = updateRating } ! [ Cmd.map RatingMessage subCmd ]

```

## Examples

See the [examples][examples] folder

[examples]: https://github.com/Bernardoow/Elm-Rating-Component/tree/master/examples