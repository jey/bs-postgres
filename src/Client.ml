type t
type config =
  < user: string Js.undefined
  ; password: string Js.undefined
  ; host: string Js.undefined
  ; database: string Js.undefined
  ; port: int Js.undefined
  ; ssl: <rejectUnauthorized: bool; ca: string; key: string; cert: string> Js.t Js.undefined
  ; statement_timeout: int Js.undefined
  >  Js.t

module Internal = struct
  external make: config -> t = "Client" [@@bs.module "pg"] [@@bs.new]

  external makeConfig:
    ?user:string ->
    ?password:string ->
    ?host:string ->
    ?database:string ->
    ?port:int ->
    ?ssl: <rejectUnauthorized: bool; ca: string; key: string; cert: string> Js.t ->
    ?statement_timeout:int ->
    unit ->
    config = "" [@@bs.obj]
end

external connect: t -> unit Js.Promise.t = "" [@@bs.send]

external query: string -> ?values:'a -> 'b Result.t Js.Promise.t = "" [@@bs.send.pipe: t]

external query': 'a Query.t -> 'a Result.t Js.Promise.t = "query" [@@bs.send.pipe: t]

external end_: t -> unit Js.Promise.t = "end" [@@bs.send]

let make ?user ?password ?host ?database ?port ?ssl ?statement_timeout () =
  Internal.make @@ Internal.makeConfig ?user ?password ?host ?database ?port ?ssl ?statement_timeout ()
