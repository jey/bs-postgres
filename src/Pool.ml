type t
type config =
  < user: string Js.undefined
  ; password: string Js.undefined
  ; host: string Js.undefined
  ; database: string Js.undefined
  ; port: int Js.undefined
  ; ssl: <rejectUnauthorized: bool; ca: string; key: string; cert: string> Js.t Js.undefined
  ; statement_timeout: int Js.undefined
  ; connectionTimeoutMillis: int Js.undefined
  ; idleTimeoutMillis: int Js.undefined
  ; max: int Js.undefined
  > Js.t

module Internal = struct
  external make: config -> t = "Pool" [@@bs.module "pg"] [@@bs.new]

  external makeConfig:
    ?user:string ->
    ?password:string ->
    ?host:string ->
    ?database:string ->
    ?port:int ->
    ?ssl: <rejectUnauthorized: bool; ca: string; key: string; cert: string> Js.t ->
    ?statement_timeout:int ->
    ?connectionTimeoutMillis:int ->
    ?idleTimeoutMillis:int ->
    ?max:int ->
    unit ->
    config = "" [@@bs.obj]
end

module Client = struct
  include Client

  external _release : t -> unit = "release"[@@bs.send ]

  let release client = (client |> _release) |> Js.Promise.resolve
end

external connect: t -> Client.t Js.Promise.t = "" [@@bs.send]

external query: string -> ?values:'a -> 'b Result.t Js.Promise.t = "" [@@bs.send.pipe: t]

external end_: t -> unit Js.Promise.t = "end" [@@bs.send]

external totalCount:   t -> int = "" [@@bs.get]
external idleCount:    t -> int = "" [@@bs.get]
external waitingCount: t -> int = "" [@@bs.get]

let make ?user ?password ?host ?database ?port ?ssl ?statement_timeout
         ?connectionTimeoutMillis ?idleTimeoutMillis ?max () =
  Internal.make @@ Internal.makeConfig ?user ?password ?host ?database ?port ?ssl ?statement_timeout
                                       ?connectionTimeoutMillis ?idleTimeoutMillis ?max ()
