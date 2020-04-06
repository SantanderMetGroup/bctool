from .wps_say_hello import SayHello
from .bc_extractor import BCExtractor

processes = [
    SayHello(),
    BCExtractor(),
]
