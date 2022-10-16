import {FileDescriptorProto} from "google-protobuf/google/protobuf/descriptor_pb";

const bytes: Uint8Array = Uint8Array.of(1,2,3,4,5);
FileDescriptorProto.deserializeBinary(bytes)
