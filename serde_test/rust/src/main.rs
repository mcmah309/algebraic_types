use axum::{
    extract::Json,
    http::StatusCode,
    response::IntoResponse,
    routing::post,
    Router,
};
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

async fn handle_request(Json(payload): Json<RequestData>) -> impl IntoResponse {
    println!("Received payload: {:?}", payload);

    (StatusCode::OK, Json(payload))
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", post(handle_request));

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    println!("Server running at http://{}", addr);

    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}