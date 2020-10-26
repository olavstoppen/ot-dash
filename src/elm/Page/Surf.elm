module Page.Surf exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view _ =
    div [ class "page surf-page" ]
        [ text "No surf today 🏄\u{1F3FB}\u{200D}♂️ 😢"
        ]
