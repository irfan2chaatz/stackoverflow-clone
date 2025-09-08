// components/AnswerList.jsx
import React, { useState } from "react";
import { format } from "date-fns";

function AnswerList({ answers }) {
  return (
    <div className="space-y-8">
      {answers.map((question, qIndex) => (
        <QuestionCard key={qIndex} question={question} qIndex={qIndex} />
      ))}
    </div>
  );
}

// Question card component
function QuestionCard({ question, qIndex }) {
  const [showAnswers, setShowAnswers] = useState(true);

  return (
    <div className="border rounded-lg shadow-md p-6 bg-white">
      {/* Question Header */}
      <div className="flex justify-between items-center mb-2">
        <h2 className="text-xl font-bold">
          Q{qIndex + 1}. {question.title}
        </h2>
        <span className="text-gray-500 text-sm">
          {question.answer_count} Answers | Score: {question.score}
        </span>
      </div>

      {/* Question Metadata */}
      <div className="flex flex-wrap items-center gap-2 text-gray-500 text-sm mb-3">
        <a
          href={question.owner.link}
          target="_blank"
          rel="noreferrer"
          className="font-semibold hover:underline"
        >
          {question.owner.display_name}
        </a>
        <span>| Created: {format(new Date(question.creation_date * 1000), "PP")}</span>
        <span>| Last activity: {format(new Date(question.last_activity_date * 1000), "PP")}</span>
        <span>
          | Tags:{" "}
          {question.tags.map((tag, i) => (
            <span
              key={i}
              className="bg-blue-100 text-blue-800 px-2 py-0.5 rounded text-xs"
            >
              {tag}
            </span>
          ))}
        </span>
      </div>

      {/* Question Link */}
      <div className="mb-4">
        <a
          href={question.link}
          target="_blank"
          rel="noreferrer"
          className="text-blue-600 hover:underline"
        >
          View on Stack Overflow
        </a>
      </div>

      {/* Toggle answers */}
      {question.answers && question.answers.length > 0 && (
        <div>
          <button
            className="mb-2 text-blue-600 hover:underline text-sm"
            onClick={() => setShowAnswers(!showAnswers)}
          >
            {showAnswers ? "Hide Answers" : "Show Answers"}
          </button>

          {showAnswers && (
            <div className="pl-4 border-l-2 border-gray-300 space-y-4">
              {question.answers.map((ans, aIndex) => (
                <AnswerCard key={aIndex} answer={ans} aIndex={aIndex} />
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

// Answer card component
function AnswerCard({ answer, aIndex }) {
  return (
    <div
      className={`flex border rounded-lg ${
        answer.is_accepted ? "bg-green-50 border-green-400" : "bg-gray-50 border-gray-200"
      }`}
    >
      {/* Vote arrows */}
      <div className="flex flex-col items-center justify-start p-2 w-12 bg-gray-100 border-r border-gray-300">
        <button className="text-gray-400 hover:text-gray-600">&#9650;</button>
        <span className="font-semibold my-1">{answer.score}</span>
        <button className="text-gray-400 hover:text-gray-600">&#9660;</button>
      </div>

      {/* Answer body */}
      <div className="p-4 flex-1">
        <div className="font-semibold mb-1">
          Answer {aIndex + 1}. {answer.is_accepted && <span className="text-green-700">Accepted</span>}
        </div>
        <div
          className="text-gray-800 mb-2"
          dangerouslySetInnerHTML={{ __html: answer.body }}
        />
        <div className="flex flex-wrap items-center gap-2 text-gray-500 text-sm">
          <a
            href={answer.owner.link}
            target="_blank"
            rel="noreferrer"
            className="font-semibold hover:underline"
          >
            {answer.owner.display_name}
          </a>
          <span>| Created: {format(new Date(answer.creation_date * 1000), "PP")}</span>
        </div>
      </div>
    </div>
  );
}

export default AnswerList;
