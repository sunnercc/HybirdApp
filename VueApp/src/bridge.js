

/***
 * 消息体结构
 * params: 参数
 * responseId: 远端执行序号
 * callbackId: 自己执行序号
 * method: 方法名
 * 
 */

window.bridge = {

    _callbackHandlers: {},
    _methodHandlers: {},

    // method: function(prams, callback);
    registerHandler: function(methodName, method) {
        this._methodHandlers[methodName] = method;
    },

    postMessage: function(method, params, callbackHandler) {
        // 构建 messageBody
        var messageBody = {}
        messageBody.method = method
        messageBody.params = params
        // 如果有回调用，则构建回调
        if (callbackHandler && typeof callbackHandler === 'function') {
            // 因为消息是要发送给 oc，所以需要转位 responseId
            var responseId = 'callbackId' + new Date().getTime();
            this._callbackHandlers[responseId] = callbackHandler;
            messageBody.responseId = responseId;
        }
        this._sendMessage(messageBody);
    },

    postSyncMessage: function(method, params) {
        try {
            var messageBody = {}
            messageBody.method = method;
            messageBody.params = params;
            var result = prompt(JSON.stringify(messageBody));
            return result;
        } catch (error) {

        }
    },

    _sendMessage: function(messageBody) {
        window.webkit.messageHandlers.WKJSBridge.postMessage(messageBody);
    },

    // 这个一般是 oc 调用
    _recvMessage: function(data) {
        var messageBody = JSON.parse(data);
        var responseId = messageBody.responseId;
        var callbackId = messageBody.callbackId;
        var params = messageBody.params;
        var method = messageBody.method;
        if (callbackId) {
            // 如果有 callbackId ，说明是要执行本地的 callback
            var callbackHandler = this._callbackHandlers[callbackId];
            if (callbackHandler) { // 执行 callbackhandler，需要将参数传递进去
                callbackHandler(params);
            } 
        } else if (method) { // 没有callbackId，说明是想调用 js 方法
            var method = this._methodHandlers[method];
            if (method) {
               if (responseId) {
                  messageBody.responseHandler = (params) => {
                    // 构建 mesageBody
                    var sendMessageBody = {}
                    sendMessageBody.callbackId = responseId;
                    sendMessageBody.params = params;
                    this._sendMessage(sendMessageBody);
                  }
               }
               method(params, messageBody.responseHandler);
            }
        }
    }    
}

