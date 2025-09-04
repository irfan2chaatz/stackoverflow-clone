// App.jsx
import React, { useState } from 'react';
import NavBar from './components/NavBar.jsx';
import SearchBar from './components/SearchBar.jsx';
import Tabs from './components/Tabs.jsx';
//import AnswerList from './components/AnswerList.jsx';
import axios from 'axios';

function App() {
  const [originalAnswers, setOriginalAnswers] = useState([]);
  const [rerankedAnswers, setRerankedAnswers] = useState([]);

  const handleSearch = async (query) => {
    try {
      // Call your backend API to fetch answers
      const response = await axios.post('http://localhost:4000/api/search', { query });
      setOriginalAnswers(response.data.original);
      setRerankedAnswers(response.data.reranked);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="max-w-4xl mx-auto px-4">
      <NavBar />
      <SearchBar onSearch={handleSearch} />
      <Tabs original={originalAnswers} reranked={rerankedAnswers} />
    </div>
  );
}

export default App;