module Views exposing (viewBackground, viewRemoteData, viewSidebar)

import Helpers exposing (formatDateTimeName, formatDayDate, fullName, getPageKey, getPageTitle, getWeekDayName)
import Html exposing (Html, a, div, h1, nav, text)
import Html.Attributes exposing (class, href, style)
import Http exposing (Error(..))
import Model exposing (Here, Model, Page(..), RemoteData(..))
import String
import Html exposing (span)


viewRemoteData : Model -> (Model -> RemoteData a) -> (Model -> Html msg) -> String -> Html msg
viewRemoteData model remoteData viewfn bg =
    case remoteData model of
        NotAsked ->
            div [ class "page" ]
                [  loadingAnim <| viewPageLogoColor model,
                    div [ class "bottom-title" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ h1 [] [ text "Starter opp..." ]
                        ]
                    ]
                ]

        Loading ->
            div [ class "page" ]
                [ loadingAnim <| viewPageLogoColor model]

        Failure err ->
            div [ class "page" ]
                [  loadingAnim <| viewPageLogoColor model,
                    div [ class "bottom-title" ]
                    [ div [ class "animated fadeInDown faster" ]
                        [ h1 [] [ text "Pingu føler seg ikke så bra..." ],
                        span [] [ text  <|httpErrorToString err ]
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


viewBackground : Model -> String -> Html msg
viewBackground { here } bgColorClass =
    div [ class <| "background " ++ bgColorClass ]
        [ div [ class (bgColorClass ++ " background__page") ] [ viewDayDate here, viewClock here ]
        ]


viewDayDate : Here -> Html msg
viewDayDate here =
    div [ class "clock" ]
        [ text <|
            formatDayDate here
        ]


viewClock : Here -> Html msg
viewClock here =
    div [ class "clock" ]
        [ text <|
            formatDateTimeName here
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
        [ div [ class "animated fadeInLeft100 link__footer__bit" ] []
        ]


loadingAnim : String -> Html msg
loadingAnim color =
    div [ class "ot-logo-loader" ]
        [ div [ class "ot-o", style "border" <| color ++ " 2.5rem solid"] []
        , div [ class "ot-t-wrapper" ]
            [ div [ class "ot-t-1", style "background-color" color] []
            , div [ class "ot-t-2", style "background-color" color ] []
            , div [ class "ot-t-3"] []
            ]
        ]
        
viewPageLogoColor : Model -> String
viewPageLogoColor model =
    case model.pages.active of
        Transit ->
            "#2B2B2B"

        Slack ->
            "#2B2B2B"

        Birthday person ->
            "#f5f5f5"

        Weather ->
            "#f5f5f5"

        Instagram ->
            "#2B2B2B"

        Lunch ->
            "#f5f5f5"

        Calendar ->
            "#2B2B2B"

        Video ->
            "#2B2B2B"

        Traffic ->
            "#2B2B2B"

        Surf ->
            "#2B2B2B"
