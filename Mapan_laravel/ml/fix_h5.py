import h5py
import json
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
MODEL_PATH = SCRIPT_DIR / 'model' / 'rice_disease_model.h5'
FIXED_MODEL_PATH = SCRIPT_DIR / 'model' / 'rice_disease_model_fixed.h5'

import shutil
shutil.copy(MODEL_PATH, FIXED_MODEL_PATH)

with h5py.File(FIXED_MODEL_PATH, 'r+') as f:
    model_config_str = f.attrs.get('model_config')
    if model_config_str:
        model_config = json.loads(model_config_str)
        # Find InputLayer and fix it
        for layer in model_config['config']['layers']:
            if layer['class_name'] == 'InputLayer':
                config = layer['config']
                if 'batch_shape' in config:
                    config['batch_input_shape'] = config.pop('batch_shape')
                if 'optional' in config:
                    del config['optional']
        f.attrs['model_config'] = json.dumps(model_config).encode('utf-8')
        print("Model config patched!")
