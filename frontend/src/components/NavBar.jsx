// components/NavBar.jsx
import React from "react";

function NavBar({ onRecentClick }) {
  return (
    <nav className="bg-blue-600 text-white px-6 py-4 flex justify-between items-center">
      <div className="font-bold text-xl">StackOverflow Clone</div>
      <div className="space-x-4">
        <button
          className="hover:bg-blue-700 px-3 py-1 rounded"
          onClick={onRecentClick}
        >
          Recent Searches
        </button>
        <button className="hover:bg-blue-700 px-3 py-1 rounded">Users</button>
      </div>
    </nav>
  );
}

export default NavBar;
