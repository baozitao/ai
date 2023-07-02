import openai
openai.api_key = "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"


# 调用API获取模型列表
models = openai.Model.list()

# 输出模型列表名称
for model in models['data']:
    print(model['id'])

# create a chat completion
chat_completion = openai.ChatCompletion.create(
    model="gpt-3.5-turbo-16k-0613",
    messages=[{"role": "user", "content": "你有多少个模型参数"}])

# print the chat completion
print(chat_completion.choices[0].message.content)
# print(chat_completion)
