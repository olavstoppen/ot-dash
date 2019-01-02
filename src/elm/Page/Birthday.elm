module Page.Birthday exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html msg
view model =
    div [] [ text "birthday page" ]
