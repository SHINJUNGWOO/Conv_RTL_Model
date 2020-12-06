# Conv_RTL_Model

- Version 1
  - 하나의 Multiplier만 이용하여 연산을 진행, Time이 오래 걸림
  - 두개의 연산기를 이용하여 Latency를 줄인다. 
  - 하나의 연산기가 Work하는 동안 다른 연산기에 작업을 시행하는 형태로 데이터 입력 멈추지 않고 연산을 계속 진행할 수 있다는 장점이 있다.



- Version 2
  - Kernel size 만큼의 Multiplier를 이용하여 연산을 진행
  - 연산 과정의 복잡성을 줄이고 병렬처리를 용이하게 함
  - Queue를 이용하여 데이터를 저장

- Python_image_process
  - Image를 처리하여 Bram에 Initialize 값인 COE 파일로 변환 (Encoder)
  - Testbench에서 나온 결과값을 이미지로 변환 (Decoder)