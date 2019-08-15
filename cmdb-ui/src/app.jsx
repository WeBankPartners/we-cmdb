import React, { Component } from "react";
import "./app.css";
import Header from "./components/header";
import AppRouter from "./router";

class App extends Component {
  render() {
    return (
      <>
        <Header />
        <div className="global-main">
          <AppRouter />
        </div>
      </>
    );
  }
}

export default App;
