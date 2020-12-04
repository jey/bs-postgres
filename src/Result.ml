type fieldSpec = {
  name: string;
  dataTypeID: int;
}

type 'a t = {
  rows: 'a array;
  fields:  fieldSpec array;
  rowCount: int;
  command:  string;
}

let map f x =
  [%bs.obj { rows     = Js.Array.map f x##rows
           ; fields   = x##fields
           ; rowCount = x##rowCount
           ; command  = x##command
           }]
