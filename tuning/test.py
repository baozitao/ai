from transformers import AutoTokenizer, AutoModel
import torch
 # 加载模型和分词器
model_name = "bert-base-uncased"  # 例如：bert-base-uncased
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModel.from_pretrained(model_name)
 # 输入文本
text = "这是一个例子句子。"
 # 分词
input_ids = tokenizer.encode(text, add_special_tokens=True)
input_ids = torch.tensor(input_ids).unsqueeze(0)  # 添加批处理维度
 # 模型推理
outputs = model(input_ids)
print(outputs)
