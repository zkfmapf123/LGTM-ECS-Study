import express from 'express'
import { counter, gauge, register } from './metrics.js'
import "./tracer.js"

let i = 1

const app = express()

app.use(express.json())

app.get("/ping",(req,res)=>{
    res.send(`${process.env.NAME} success`)
})

app.get("/metrics", async (req, res) => {
    res.set('Content-Type', register.contentType)
    res.end(await register.metrics())
})

app.get("/sub", async(req,res) => {
    const delay = Math.floor(Math.random() * (10000 - 1000 + 1)) + 1000;
    await new Promise(resolve => setTimeout(resolve, delay));
    
    res.json({  
        message: "Hello Subscribe...",
        delay: delay / 1000 + " seconds"
    });
})

app.get("/pub", async(req,res) =>{

    const resData = await axios.get(`${process.env.SVC_URL}/sub`)
    const data = resData.data

    return res.status(200).json(data)
})


app.listen(3000,()=>{
    console.log("server is running on port 3000")
})

setInterval(()=>{

    counter.inc()
    gauge.set(i)

    console.log(`${process.env.NAME} ${i++} logs`)
    
}, 10000) // 10s
