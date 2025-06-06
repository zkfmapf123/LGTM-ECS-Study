import { getNodeAutoInstrumentations } from "@opentelemetry/auto-instrumentations-node";
import { OTLPTraceExporter } from "@opentelemetry/exporter-trace-otlp-http";
import { NodeSDK } from "@opentelemetry/sdk-node";

const sdk = new NodeSDK({
    traceExporter: new OTLPTraceExporter({
        url: "https://tempo.leedonggyu.com/v1/traces",
        headers : {}
    }),
    instrumentations: [getNodeAutoInstrumentations()],
    serviceName: `${process.env.NAME}-svc`,
})


async function startTracing() {
    try {
        await sdk.start();
        console.log(`Tracing ${process.env.NAME}-svc is running`);
    } catch (error) {
        console.error("Error starting tracing", error);
    }
}

startTracing();

process.on('SIGTERM', () => {
    sdk.shutdown()
        .then(() => console.log('Tracing terminated'))
        .catch((error) => console.log('Error terminating tracing', error))
        .finally(() => process.exit(0));
});