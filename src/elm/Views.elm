module Views exposing (viewBackground, viewRemoteData, viewSidebar)

import Helpers exposing (formatTime, fullName, getPageKey, getPageTitle, getWeekDayName)
import Html exposing (Html, a, div, h1, nav, text)
import Html.Attributes exposing (class, href)
import Http exposing (Error(..))
import Model exposing (Here, Model, Page(..), RemoteData(..))
import String


viewRemoteData : Model -> (Model -> RemoteData a) -> (Model -> Html msg) -> Html msg
viewRemoteData model remoteData viewfn =
    case remoteData model of
        NotAsked ->
            div [ class "page" ]
                [ div [ class "title" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ h1 [] [ text "Starter opp... ️️🏗️" ]
                        ]
                    ]
                ]

        Loading ->
            div [ class "page" ]
                [ div [ class "title" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ h1 [] [ text "Laster... ⏳" ]
                        ]
                    ]
                ]

        Failure err ->
            div [ class "page" ]
                [ div [ class "title" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ h1 [] [ text "Pingu føler seg ikke så bra... \u{1F912}" ]
                        ]
                    ]
                , div [ class "content" ]
                    [ div [ class "animated fadeInDown faster " ]
                        [ div [] [ text <| httpErrorToString err ]
                        ]
                    ]
                ]

        Success _ ->
            viewfn model


httpErrorToString : Error -> String
httpErrorToString err =
    case err of
        BadUrl url ->
            "BadUrl: " ++ url

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus code ->
            "BadStatus: " ++ String.fromInt code

        BadBody string ->
            "BadBody: " ++ string


viewBackground : Model -> Html msg
viewBackground { here } =
    div [ class "background" ]
        [ div [ class "background__page" ] []
        , div [ class "background__divider" ]
            [ viewClock here
            ]
        , div [ class "background__sidebar" ] []
        ]


viewClock : Here -> Html msg
viewClock { zone, time, day } =
    div [ class "clock" ]
        [ text <|
            String.concat
                [ getWeekDayName day
                , ", kl. "
                , formatTime zone time
                ]
        ]


viewSidebar : Model -> Html msg
viewSidebar { pages } =
    nav [ class "sidebar" ] <| List.map (viewLink pages.active) pages.available


viewLink : Page -> Page -> Html msg
viewLink activePage page =
    let
        url =
            "/" ++ getPageKey page

        title =
            getPageTitle page

        isActive =
            case page of
                Birthday person ->
                    case activePage of
                        Birthday personActive ->
                            fullName person == fullName personActive

                        _ ->
                            activePage == page

                _ ->
                    activePage == page
    in
    if isActive then
        a [ href url, class "active" ]
            [ div [ class "link__title " ] [ text title ]
            , viewLinkFooter
            ]

    else
        a [ href url ] [ div [ class "link__title " ] [ text title ] ]


viewLinkFooter : Html msg
viewLinkFooter =
    div [ class "link__footer" ]
        [ div [ class "animated slideInLeft link__footer__bit" ] []
        ]
