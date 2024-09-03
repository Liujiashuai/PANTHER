> PANTHER 原型编码过程；

# 代码运行

代码链接：https://github.com/Liujiashuai/PANTHER

* prototype

首先通过kmeans得到初始化的原型：

```
cd src
bash ./script/prototype/GTEx_TCGA.sh 0
```

根据不同放大倍数的需要，修改`./script/prototype/clustering.sh`中 `mag` 和 与之对应的 `n_proto`。

* embedding

```
cd src
bash ./script/embedding/GTEx_TCGA.sh 0 panther
```

根据不同放大倍数的需要，修改`./script/embedding/panther.sh`中 `mag` 和 与之对应的 `out_size`。


# 输出格式

输出文件保存在 ./splits/GTEx-TCGA-class下，由于github空间有限，因此没有保存结果。

```text
|---project_name
|   |---0_1024
|   |   |---embeddings
|   |   |---embeddings
|   |   |---└---***tokenized.pkl
|   |   |---└---***.pkl
|   |   |---prototypes
|   |   |---└---***.pkl
|   |   └---train.csv
|   |---1_512
└   └---1_1024
```

其中，`***tokenized.pkl`表示经过 token化之后每个wsi的特征；`***.pkl`是没有对`prob`，`mean`以及`cov`进行区分的特征向量。shape为`[wsi_num, proto_num* (input_dim*2+1)]`

保留了其中的`***tokenized.pkl`文件和`***.pkl`，该文件可以通过下面的方式进行加载：

```python
import os
import pickle

embedding_path = './src/splits/GTEx-TCGA-class/TCGA-BLCA/1_1024/embeddings'


os.listdir(embedding_path)
for file_name in os.listdir(embedding_path):
    if file_name.endswith('.pkl'):
        if file_name.endswith('tokenized.pkl'):
            with open(os.path.join(embedding_path, file_name), 'rb') as f:
                data_token = pickle.load(f)
        else:
            with open(os.path.join(embedding_path, file_name), 'rb') as f:
                data_embedding = pickle.load(f)

print(data_embedding['train']['X'].shape)
print(data_token['train']['prob'].shape)
print(data_token['train']['mean'].shape)
print(data_token['train']['cov'].shape)

# torch.Size([457, 8200])  # [wsi_num, proto_num*(input_dim*2+1)]
# torch.Size([457, 8])  # [wsi_num, proto_num], feature for prob
# torch.Size([457, 8, 512])  # [wsi_num, proto_num, input_dim], feature for mean
# torch.Size([457, 8, 512])  # [wsi_num, proto_num, input_dim], feature for cov
```

# 使用方法
可以直接将特征进行合并，用于下游任务。作者的代码是将所有的`prob`放在WSI特征列表的`[: proto_num]`，`mean`放在`[proto_num, proto_num*(d+1)]`，`cov`放在`[proto_num*(d+1):]`中，直接用于下游任务的训练和预测。

此外，作者在代码中还给出了一种额外的方案：不同原型得到的特征分别进行映射，然后再通过线性层对结果进行组合。
