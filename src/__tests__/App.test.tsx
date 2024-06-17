import React from "react";
import { render, screen } from "@testing-library/react";
import App from "../App";

// 画面にLearn Reactの文字が出るかテスト
test("renders learn react link", () => {
  render(<App />);
  const linkElement = screen.getByText(/learn react/i);
  expect(linkElement).toBeInTheDocument();
});
