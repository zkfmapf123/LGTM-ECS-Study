import { Counter, Gauge, Registry } from 'prom-client'


export const register = new Registry()

export const counter = new Counter({
    name : `${process.env.NAME}_counter`,
    help : "Number of hello logs",
    registers : [register]
})

export const gauge = new Gauge({
    name: `${process.env.NAME}_gauge`,
    help : "Current value of i",
    registers : [register]
})