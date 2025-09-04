// components/SearchBar.jsx
import React, { useState } from "react";

function SearchBar({ onSearch }) {
  const [query, setQuery] = useState("");

  const handleSearch = () => {
    if (query.trim()) onSearch(query);
  };

  return (
    <div className="my-6 flex">
      <input
        type="text"
        placeholder="Type your question..."
        className="flex-1 border border-gray-300 rounded-l px-4 py-2 focus:outline-none"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />
      <button
        className="bg-blue-600 text-white px-4 py-2 rounded-r hover:bg-blue-700"
        onClick={handleSearch}
      >
        Ask Question
      </button>
    </div>
  );
}

export default SearchBar;
