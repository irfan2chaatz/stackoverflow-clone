// components/AnswerList.jsx
import React from "react";

function AnswerList({ answers }) {
  return (
    <div className="space-y-4">
      {answers.map((answer, index) => (
        <div key={index} className="border p-4 rounded shadow-sm">
          <div className="font-bold text-lg">{answer.title}</div>
          <div className="text-gray-700 mt-1">{answer.body}</div>
          <div className="text-gray-400 text-sm mt-2">
            Votes: {answer.score} | Author: {answer.author}
          </div>
        </div>
      ))}
    </div>
  );
}

export default AnswerList;
