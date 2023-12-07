'use client'

import { useState } from "react"
import Image from "next/image"
import ReactJson from 'react-json-view'
import '@/assets/styles/admin.css'

export default function Admin() {
  const [email, setEmail] = useState()
  const [password, setPassword] = useState()
  
  const [gameList, setGameList] = useState()
  const [selectedGameId, setSelectedGameId] = useState()
  const [levelList, setLevelList] = useState()
  const [selectedLevelId, setSelectedLevelId] = useState()

  const [levelJSON, setLevelJSON] = useState()

  async function getGameList() {
    const res = await fetch(`http://localhost:3000/api/games`)
    const data = await res.json()

    return data.gameList
  }

  async function getLevelList(gameId) {
    const res = await fetch(`http://localhost:3000/api/levels`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ gameId })
    })
    const data = await res.json()

    return data.levelList
  }


  async function handleLogin() {
    const user = {
      email,
      password
    }

    const res = await fetch(`http://localhost:3000/api/auth/login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(user)
    })

    const data = await res.json()
    
    if (!data.user) {
      alert("Đăng nhập không thành công!")
    } else {
      alert("Đăng nhập thành công!")
      const gameList = await getGameList()
      if (gameList) {
        setGameList(gameList)
      }
    }
  }

  async function handleSelectGame(gameId) {
    const levelList = await getLevelList(gameId)
      if (levelList) {
        setLevelList(levelList)
      }
  }

  async function handleSelectLevel(levelId) {
    setSelectedLevelId(levelId)
    setLevelJSON(levelList.find((level) => level.id == levelId))
  }

  // function handleEditLevelJSON(e) {
  //   const newLevelJSON = JSON.parse(e.target.innerText)
  //   setLevelJSON(newLevelJSON)
  // }

  function handleEditLevelJSON(edit) {
    const { updated_src } = edit

    setLevelJSON(updated_src)
  }

  async function handleAddLevel() {
    const levelJSONClone = { ...levelJSON } // nông
    //const levelJSONClone = JSON.parse(JSON.stringify(levelJSON)) // sâu
    delete levelJSONClone.id

    const res = await fetch(`http://localhost:3000/api/levels/add`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ level: levelJSONClone })
    })

    const data = await res.json()
    //console.log(data)
    //console.log(JSON.stringify(levelJSON))
  }

  async function handleUpdateLevel() {
    const levelJSONClone = { ...levelJSON }
    delete levelJSONClone.id

    const res = await fetch(`http://localhost:3000/api/levels/update`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ level: levelJSONClone, levelId: levelJSON.id })
    })

    const data = await res.json()
    //console.log(data)
  }


  return (
    <main className="container">
      <h1>Admin - Nhà trường - Giáo viên</h1>
      {
        !gameList && (
          <div className="login-container">
            <input type="email" placeholder="email" value={email} onChange={(e) => setEmail(e.target.value)} />
            <input type="password" placeholder="password" value={password} onChange={(e) => setPassword(e.target.value)} />
            <button type="button" onClick={handleLogin}>Login</button>
          </div>
        )
      }
      <div className="body">
        <div className="game-list-contaier">
          <h2>Các trò chơi</h2>
          <ul className="game-list">
          {
            gameList && gameList.filter((game) => game.status == "active").map((game, index) => {
              return (
                <li key={index} className="game-item" onClick={() => handleSelectGame(game.id)}>
                  <p>{game.gameName.replace(/\\n/g, "\n")}</p>
                  {/* <img src={game.thumbnail_url} width={100} height={100} alt={game.gameName}/> */}
                </li>
              )
            })
          }
          </ul>
        </div>
        <div className="level-list-contaier">
          <ul className="level-list">
            <h2>Các màn chơi</h2>
            {
              levelList && levelList.map((level, index) => {
                return (
                  <li key={index} className="level-item" onClick={() => handleSelectLevel(level.id)}>
                    <p>{level.title}</p>
                    {/* <img src={level.thumbnail_url} width={100} height={100} alt={level.title}/> */}
                  </li>
                )
              })
            }
          </ul>
          {
            levelJSON && (
              // <div 
              //   contentEditable
              //   onInput={(e) => handleEditLevelJSON(e)}
              //   className="selected-level"
              //   style={{ border: '1px solid #ccc', padding: '8px', margin: '16px', minHeight: '100px' }}
              // >
              //   {
              //     JSON.stringify(levelList.find((level) => level.id == selectedLevelId))
              //   }
              // </div>
              <div className="level-json-container">
                <h2>Nội dung màn chơi</h2>
                <button type="button" className="level-btn" onClick={handleAddLevel}>Thêm</button>
                <button type="button" className="level-btn" onClick={handleUpdateLevel}>Cập nhật</button>
                <ReactJson onEdit={handleEditLevelJSON} src={ levelJSON } />
              </div>
            )
          }
        </div>
      </div>
    </main>
  )
}
  