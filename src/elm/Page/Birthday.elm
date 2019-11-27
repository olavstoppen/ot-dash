module Page.Birthday exposing (view)

import Helpers exposing (fullName)
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class, src)
import Model exposing (Href, Person)


view : Person -> Html msg
view person =
    div [ class "page birthday-page" ]
        [ greeting person
        , background "https://images.unsplash.com/photo-1495934270965-eca97329fde8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80"
        ]


greeting : Person -> Html msg
greeting person =
    div [ class "content--middle" ]
        [ div [ class "animated fadeInDown faster " ]
            [ div [ class "birthday-greeting" ]
                [ h1 [] [ text <| "🎂 Gratulere med dagen, " ++ fullName person ++ "! 🎂" ]
                ]
            ]
        ]


background : Href -> Html msg
background imageUrl =
    div [ class "content--full" ]
        [ div [ class "birthday-background" ] [ img [ src imageUrl ] [] ]
        ]
