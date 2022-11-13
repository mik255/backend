

enum ResultResponse{
created,
deleted,
updated,
sucess,
}

String getResultMapString(ResultResponse response){
return {"result":response.name}.toString();
}