import onnxruntime as ort
import numpy as np
from PIL import Image
import os

model_path = r"C:\Users\MyBook Hype AMD\Downloads\Telegram Desktop\mapan\mapan\assets\models\model.onnx"
sess = ort.InferenceSession(model_path)

blb_dir = r"C:\Users\MyBook Hype AMD\tugas_uts_pcs\ml\dataset_split\train\Bacterial Leaf Blight"
files = os.listdir(blb_dir)[:10]

print("Testing Bacterial Leaf Blight (Expected Class 0):")
for f in files:
    img_path = os.path.join(blb_dir, f)
    img = Image.open(img_path).resize((224, 224))
    
    # Ensure it has 3 channels (RGB)
    img = img.convert('RGB')
    
    arr = (np.array(img, dtype=np.float32) / 127.5) - 1.0
    arr = np.expand_dims(arr, axis=0)
    
    out = sess.run(None, {sess.get_inputs()[0].name: arr})[0]
    pred_idx = np.argmax(out)
    pred_conf = np.max(out)
    print(f"File: {f} | Pred: {pred_idx} | Conf: {pred_conf:.4f}")
