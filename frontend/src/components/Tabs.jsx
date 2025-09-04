// components/Tabs.jsx
import React, { useState } from "react";
import AnswerList from "./AnswerList";

function Tabs({ original, reranked }) {
  const [active, setActive] = useState("original");

  return (
    <div>
      <div className="flex space-x-2 mb-4">
        <button
          className={`px-4 py-2 ${
            active === "original" ? "bg-blue-600 text-white" : "bg-gray-200"
          }`}
          onClick={() => setActive("original")}
        >
          Original Answers
        </button>
        <button
          className={`px-4 py-2 ${
            active === "reranked" ? "bg-blue-600 text-white" : "bg-gray-200"
          }`}
          onClick={() => setActive("reranked")}
        >
          Reranked Answers
        </button>
      </div>
      {active === "original" ? (
        <AnswerList answers={original} />
      ) : (
        <AnswerList answers={reranked} />
      )}
    </div>
  );
}

export default Tabs;
