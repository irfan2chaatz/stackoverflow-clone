// components/GeneralTabs.jsx
import React, { useState, useEffect } from "react";
import axios from "axios";
import { formatDistanceToNow } from "date-fns";

function GeneralTabs() {
  const [active, setActive] = useState("questions");
  const [questions, setQuestions] = useState([]);
  const [tags, setTags] = useState([]);
  const [page, setPage] = useState(1);

  useEffect(() => {
    if (active === "questions") fetchQuestions(page);
    else fetchTags(page);
  }, [active, page]);

  const fetchQuestions = async (page, sort = "votes") => {
    try {
      const res = await axios.get(
        `http://localhost:4000/api/popular_questions?sort=${sort}&page=${page}`
      );
      setQuestions(res.data.questions);
    } catch (err) {
      console.error("Error fetching questions:", err);
    }
  };

  const fetchTags = async (page) => {
    try {
      const res = await axios.get(
        `http://localhost:4000/api/tags?page=${page}`
      );
      setTags(res.data.tags);
    } catch (err) {
      console.error("Error fetching tags:", err);
    }
  };

  return (
    <div>
      {/* Sub-tabs */}
      <div className="flex space-x-2 mb-4">
        <button
          className={`px-4 py-2 ${
            active === "questions" ? "bg-blue-600 text-white" : "bg-gray-200"
          }`}
          onClick={() => {
            setActive("questions");
            setPage(1);
          }}
        >
          Questions
        </button>

        <button
          className={`px-4 py-2 ${
            active === "tags" ? "bg-blue-600 text-white" : "bg-gray-200"
          }`}
          onClick={() => {
            setActive("tags");
            setPage(1);
          }}
        >
          Tags
        </button>
      </div>

      {/* Content */}
      {active === "questions" ? (
        <div>
          {questions.map((q, i) => {
            const createdAt = new Date(q.creation_date * 1000); // seconds → ms
            const lastActiveAt = new Date(q.last_activity_date * 1000);

            const askedAgo = formatDistanceToNow(createdAt, {
              addSuffix: true,
            });
            const activeAgo = formatDistanceToNow(lastActiveAt, {
              addSuffix: true,
            });

            return (
              <div key={i} className="border p-4 rounded mb-3 shadow-sm">
                <div className="flex items-center space-x-2">
                  <span className="font-bold text-gray-600">
                    Q{(page - 1) * 10 + (i + 1)}.
                  </span>
                  <a
                    href={q.link}
                    target="_blank"
                    rel="noreferrer"
                    className="font-semibold text-blue-600 text-lg hover:underline"
                  >
                    {q.title}
                  </a>
                </div>

                <div className="text-gray-500 text-sm mt-1">
                  Score: <span className="font-medium">{q.score}</span> |
                  Answers: <span className="font-medium">{q.answer_count}</span>{" "}
                  | Asked by:{" "}
                  <a
                    href={q.owner.link}
                    target="_blank"
                    rel="noreferrer"
                    className="text-blue-500 hover:underline"
                  >
                    {q.owner.display_name}
                  </a>
                </div>

                <div className="text-gray-400 text-xs mt-1">
                  🕒 asked {askedAgo} • active {activeAgo}
                </div>

                <div className="flex gap-2 mt-2 flex-wrap">
                  {q.tags.map((tag, j) => (
                    <span
                      key={j}
                      className="bg-blue-100 text-blue-700 px-2 py-1 rounded text-xs font-medium"
                    >
                      {tag}
                    </span>
                  ))}
                </div>
              </div>
            );
          })}

          <Pagination page={page} setPage={setPage} />
        </div>
      ) : (
        <div className="grid grid-cols-3 gap-2">
          {tags.map((tag, i) => (
            <div
              key={i}
              className="bg-blue-100 text-blue-800 px-2 py-1 rounded text-sm text-center"
            >
              {tag.name} ({tag.count})
            </div>
          ))}
          <Pagination page={page} setPage={setPage} />
        </div>
      )}
    </div>
  );
}

function Pagination({ page, setPage }) {
  return (
    <div className="flex space-x-2 mt-4 justify-center">
      <button
        onClick={() => setPage(page - 1)}
        disabled={page <= 1}
        className="px-3 py-1 border rounded disabled:opacity-50"
      >
        Prev
      </button>
      <span className="px-3 py-1">{page}</span>
      <button
        onClick={() => setPage(page + 1)}
        className="px-3 py-1 border rounded"
      >
        Next
      </button>
    </div>
  );
}

export default GeneralTabs;
