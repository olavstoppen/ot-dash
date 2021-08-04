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
        div[class "emoji"][text "🎁"],
        div[class "emoji"][text "🎉"],
        div[class "emoji"][text "🎂"],
        div[class "emoji"][text "🤩"],
        div[class "emoji"][text "❤️️"],
        div[class "emoji"][text "✨"],
        div[class "emoji"][text "🎊"],
        div[class "emoji"][text "🍾"],
        div[class "emoji"][text "🎇"],
        div[class "emoji"][text "🎈"]
    ]