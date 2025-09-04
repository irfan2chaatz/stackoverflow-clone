import './App.css';
import { useState } from 'react';

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
     <h1 className="text-4xl font-bold text-blue-500">Hello Tailwind!</h1>
    </>
  )
}

export default App
