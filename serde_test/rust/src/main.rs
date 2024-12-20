use axum::{Router, extract::Json, http::StatusCode, response::IntoResponse, routing::post};
use serde::{Deserialize, Serialize};
use std::net::SocketAddr;

#[derive(Serialize, Deserialize, Debug)]
struct RequestData {
    message: String,
    action: Action,
}

#[derive(Serialize, Deserialize, Debug)]
enum Action {
    Create(CreateData),
    Delete,
}

#[derive(Serialize, Deserialize, Debug)]
struct CreateData {
    id: u32,
    name: String,
}

async fn struct_enum_struct(Json(payload): Json<RequestData>) -> impl IntoResponse {
    println!("struct_enum_struct received payload: {:?}", payload);

    (StatusCode::OK, Json(payload))
}

async fn enum_struct(Json(payload): Json<Action>) -> impl IntoResponse {
    println!("enum_struct received payload: {:?}", payload);

    (StatusCode::OK, Json(payload))
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/enum_struct", post(enum_struct))
        .route("/struct_enum_struct", post(struct_enum_struct));

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    println!("Server running at http://{}", addr);

    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}
