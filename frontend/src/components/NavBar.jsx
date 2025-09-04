// components/Navbar.jsx
import React from "react";

function NavBar() {
  return (
    <nav className="bg-blue-600 text-white px-6 py-4 flex justify-between items-center">
      <div className="font-bold text-xl">StackOverflow Clone</div>
      <div className="space-x-4">
        <button className="hover:bg-blue-700 px-3 py-1 rounded">
          Questions
        </button>
        <button className="hover:bg-blue-700 px-3 py-1 rounded">Tags</button>
        <button className="hover:bg-blue-700 px-3 py-1 rounded">Users</button>
      </div>
    </nav>
  );
}

export default NavBar;
