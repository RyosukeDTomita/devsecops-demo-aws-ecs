// import React from "react";
// import { render, screen } from "@testing-library/react";
// import App from "../App";
// const message: string = process.env.REACT_APP_MESSAGE || "";

// // 画面にHello, Reactの文字が出るかテスト
// test("renders Hello, React link", () => {
//   render(<App />);
//   const linkElement = screen.getByText(new RegExp(`Hello, React ${message}`, 'i'));
//   expect(linkElement).toBeInTheDocument();
// });

import React from "react";
import { render, screen } from "@testing-library/react";
import App from "../App";

// 環境変数をテストの前に設定
const originalEnv = process.env;
beforeEach(() => {
  jest.resetModules(); // モジュールキャッシュをクリア
  process.env = { ...originalEnv }; // 環境変数をリセット
});

afterAll(() => {
  process.env = originalEnv; // 全テスト後に環境変数を元に戻す
});

// 画面に"Hello, React"の文字が出るかテスト（環境変数なし）
test("renders 'Hello, React' text without environment variable", () => {
  process.env.REACT_APP_MESSAGE = ""; // 環境変数をクリア
  render(<App />);
  const linkElement = screen.getByText(/Hello, React/i);
  expect(linkElement).toBeInTheDocument();
});

// 画面に"Hello, React"と環境変数のメッセージが出るかテスト（環境変数あり）
test("renders 'Hello, React' text with environment variable", () => {
  const message: string = process.env.REACT_APP_MESSAGE || "";
  const testMessage: string = "Hello, React " + message;
  render(<App />);
  const linkElement = screen.getByText(new RegExp(testMessage, "i"));
  expect(linkElement).toBeInTheDocument();
});
