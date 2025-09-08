// App.jsx
import React, { useState } from "react";
import NavBar from "./components/NavBar.jsx";
import SearchBar from "./components/SearchBar.jsx";
import Tabs from "./components/Tabs.jsx";
import GeneralTabs from "./components/GeneralTabs.jsx";
import axios from "axios";

function App() {
  const [originalAnswers, setOriginalAnswers] = useState([]);
  const [rerankedAnswers, setRerankedAnswers] = useState([]);
  const [view, setView] = useState("search");

  const handleSearch = async (query) => {
    try {
      const response = await axios.get(
        `http://localhost:4000/api/search?q=${query}`
      );
      setOriginalAnswers(response.data.answers);
      setRerankedAnswers(response.data.reranked_answers);
      setView("search");
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="max-w-5xl mx-auto px-4">
      {/* Top Navigation */}
      <NavBar />

      {/* Main Buttons to switch view */}
      <div className="flex gap-4 my-4">
        <button
          className={`px-4 py-2 ${
            view === "search" ? "bg-blue-600 text-white" : "bg-gray-200"
          }`}
          onClick={() => setView("search")}
        >
          Search
        </button>
        <button
          className={`px-4 py-2 ${
            view === "general" ? "bg-blue-600 text-white" : "bg-gray-200"
          }`}
          onClick={() => setView("general")}
        >
          Questions & Tags
        </button>
      </div>

      {/* Conditionally render sections */}
      {view === "search" && (
        <>
          <SearchBar onSearch={handleSearch} />
          <Tabs original={originalAnswers} reranked={rerankedAnswers} />
        </>
      )}

      {view === "general" && <GeneralTabs />}
    </div>
  );
}

export default App;
