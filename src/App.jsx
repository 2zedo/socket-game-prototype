import { useEffect, useRef } from 'react'
import Phaser from 'phaser'
import { PowerStripScene } from './game/PowerStripScene'
import './App.css'

function App() {
  const gameRootRef = useRef(null)

  useEffect(() => {
    if (!gameRootRef.current) {
      return undefined
    }

    const game = new Phaser.Game({
      type: Phaser.AUTO,
      parent: gameRootRef.current,
      backgroundColor: '#f6f4ef',
      scale: {
        mode: Phaser.Scale.RESIZE,
        width: gameRootRef.current.clientWidth,
        height: gameRootRef.current.clientHeight,
      },
      scene: [PowerStripScene],
    })

    return () => {
      game.destroy(true)
    }
  }, [])

  return <main ref={gameRootRef} className="game-shell" aria-label="Power strip prototype" />
}

export default App
