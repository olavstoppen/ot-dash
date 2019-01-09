port module Updates exposing (getActivePage, pages, update, urlParser)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Helpers exposing (getPageKey, sortTransport)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import List exposing (..)
import Model exposing (..)
import Page.Birthday as Birthday
import Page.Instagram as Instagram
import Page.Lunch as Lunch
import Page.Slack as Slack
import Page.Transit as Transit
import Page.Weather as Weather
import Services exposing (..)
import Task
import Time exposing (..)
import Tuple exposing (..)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser)



-- ---------------------------
-- UPDATE
-- ---------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        SetTimeZone zone ->
            ( { model | zone = zone }, Cmd.none )

        OnUrlRequest urlRequest ->
            ( model, handleUrlRequest model.key urlRequest )

        OnUrlChange url ->
            let
                urlPage =
                    Maybe.withDefault (second model.activePage) <| UrlParser.parse urlParser url

                nextPage =
                    getActivePage urlPage
            in
            ( { model | activePage = nextPage }, Cmd.none )

        UpdateNow now ->
            let
                nextPageCountdown =
                    model.pageCountdown - 1

                updatedModel =
                    { model | now = now }
            in
            if nextPageCountdown < 0 then
                let
                    nextUrlPage =
                        first model.activePage
                            |> (+) 1
                            |> getActivePage_
                            |> second
                in
                ( { updatedModel | pageCountdown = 30 }, Nav.pushUrl model.key <| getPageKey nextUrlPage )

            else
                ( { updatedModel | pageCountdown = nextPageCountdown }, Cmd.none )

        UpdateSlackEvents res ->
            case res of
                Ok events ->
                    ( { model | slackEvents = Success events }, Cmd.none )

                Err err ->
                    ( { model | slackEvents = Failure err }, Cmd.none )

        UpdateWeather res ->
            case res of
                Ok weatherInfo ->
                    ( { model | weatherInfo = Success weatherInfo }, Cmd.none )

                Err err ->
                    ( { model | weatherInfo = Failure err }, Cmd.none )

        UpdateInstagram res ->
            case res of
                Ok instagram ->
                    ( { model | instagram = Success instagram }, Cmd.none )

                Err err ->
                    ( { model | instagram = Failure err }, Cmd.none )

        UpdatePublicTransport res ->
            case res of
                Ok publicTransports ->
                    ( { model | publicTransport = Success <| sortWith sortTransport <| List.concat publicTransports }, Cmd.none )

                Err err ->
                    ( { model | publicTransport = Failure err }, Cmd.none )

        UpdateSlackInfo res ->
            case res of
                Ok slackInfo ->
                    ( { model | slackInfo = Success slackInfo }, Cmd.none )

                Err err ->
                    ( { model | slackInfo = Failure err }, Cmd.none )

        UpdateLunchMenu res ->
            case res of
                Ok lunchMenu ->
                    ( { model | lunchMenu = Success lunchMenu }, Cmd.none )

                Err err ->
                    ( { model | lunchMenu = Failure err }, Cmd.none )


handleUrlRequest : Key -> UrlRequest -> Cmd Msg
handleUrlRequest key urlRequest =
    case urlRequest of
        Internal url ->
            Nav.pushUrl key (Url.toString url)

        External url ->
            Nav.load url


urlParser : Parser (Page -> msg) msg
urlParser =
    UrlParser.oneOf
        [ UrlParser.map Transit <| UrlParser.s "transit"
        , UrlParser.map Slack <| UrlParser.s "slack"
        , UrlParser.map Birthday <| UrlParser.s "birthday"
        , UrlParser.map Instagram <| UrlParser.s "instagram"
        , UrlParser.map Weather <| UrlParser.s "weather"
        , UrlParser.map Lunch <| UrlParser.s "lunch"
        ]


staticPages : List Page
staticPages =
    [ Transit
    , Slack
    , Birthday
    , Instagram
    , Weather
    , Lunch
    ]


getActivePage : Page -> ( Int, Page )
getActivePage page =
    List.indexedMap pair staticPages
        |> List.filter (\( _, page_ ) -> page == page_)
        |> List.head
        |> Maybe.withDefault ( 0, Transit )


getActivePage_ : Int -> ( Int, Page )
getActivePage_ index =
    List.indexedMap pair staticPages
        |> List.filter (\( index_, _ ) -> index == index_)
        |> List.head
        |> Maybe.withDefault ( 0, Transit )


pages : List ( Int, Page )
pages =
    List.indexedMap pair staticPages
