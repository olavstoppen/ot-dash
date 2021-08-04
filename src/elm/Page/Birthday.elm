module Page.Birthday exposing (view)

import Helpers exposing (fullName)
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (class, src)
import Model exposing (Href, Person)
import Model exposing (Msg)


view : Person -> Html msg
view person =
    div [ class "page birthday-page" ]
        [ emojiRain, greeting person
        ]


greeting : Person -> Html msg 
greeting person =
    div [ class "birthday-wrapper" ]
        [ div [ class "animated fadeInDown faster " ]
            [ div [ class "birthday-greeting" ]
                [ h1 [] [ text <| fullName person ++ " har bursdag!" ]
                ]
            ]
        ]


emojiRain : Html msg
emojiRain = 
    div [class "emojis"][
        div[class "emoji"][text "🎁"], --0
        div[class "emoji"][text "🎉"], --1
        div[class "emoji"][text "🎂"], --2
        div[class "emoji"][text "🤩"], --3
        div[class "emoji"][text "❤️️"], --4
        div[class "emoji"][text "✨"], --5
        div[class "emoji"][text "🎊"], --6
        div[class "emoji"][text "🍾"], --7
        div[class "emoji"][text "🎈"], --8
        div[class "emoji"][text "🍷"], --9 
        div[class "emoji"][text "🎶"], --10
        div[class "emoji"][text "🥂"], --11
        div[class "emoji"][text "👑"], --12
        div[class "emoji"][text "🎇"], --13
        div[class "emoji"][text "💃"] --14
    ]