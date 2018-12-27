module Model exposing (Model, Msg(..), initModel)

import Http exposing (Error(..))


type alias Model =
    { counter : Int
    , serverMessage : String
    }


type Msg
    = Inc
    | TestServer
    | OnServerResponse (Result Http.Error String)


initModel : Int -> Model
initModel flags =
    { counter = flags, serverMessage = "" }
