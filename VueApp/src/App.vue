<script>
export default {
  data() {
    return {
      message: "Hello World!",
    };
  },
  methods: {
    init() {
      window.bridge.registerHandler("JSLog", (params, callback) => {
        JSON.stringfiy;
        this.message = `${new Date().getTime()} oc->js: params: ${JSON.stringify(
          params
        )}`;
        callback({
          result1: "result1",
          result2: "result2",
        });
      });
    },
    sendMessage() {
      window.bridge.postMessage(
        "OCLog",
        {
          message: "message babababa",
        },
        (params) => {
          this.message = `${new Date().getTime()} oc->js: callback: ${JSON.stringify(
            params
          )}`;
        }
      );
    },
    sendSyncMessage() {
      var result = window.bridge.postSyncMessage("OCLog", {
        message: "messagebababas",
      });
      this.message = `${new Date().getTime()} receve sync message: ${result}`;
    },
  },
};
</script>

<template>
  <h5>{{ message }}</h5>
  <button @click="init">init</button>
  <button @click="sendMessage">sendMessage</button>
  <button @click="sendSyncMessage">sendSyncMessage</button>
</template>

<style>
button,
a {
  display: block;
  margin-bottom: 1em;
}
</style>
