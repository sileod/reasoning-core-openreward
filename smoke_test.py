import os

os.environ.setdefault("RC_NUM_TRAIN", "1")
os.environ.setdefault("RC_NUM_TEST", "1")

from server import AnswerParams, ReasoningCore


train = ReasoningCore.list_tasks("train")
test = ReasoningCore.list_tasks("test")
assert len(train) == 1
assert len(test) == 1

env = ReasoningCore(train[0])
out = env.answer(AnswerParams(answer=train[0]["answer"]))
assert out.finished
assert out.reward == 1
print("openreward smoke ok")
