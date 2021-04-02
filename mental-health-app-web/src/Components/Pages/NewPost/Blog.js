import { useRef, useState } from "react";
import firebase from 'firebase/app';
import firestore, {storage} from "../../../firebaseConfig";
import { CKEditor } from "@ckeditor/ckeditor5-react";
import ClassicEditor from "@ckeditor/ckeditor5-build-classic";
import { useAuth } from "../../../Context/AuthContext";
import {
    Modal,
    ModalOverlay,
    ModalContent,
    ModalHeader,
    ModalFooter,
    ModalBody,
    FormControl,
    Input,
    Textarea,
    FormLabel,
    Button,
    useToast,
} from "@chakra-ui/react";
import { useNavigate } from "react-router";
import './editor.scss';

class MyUploadAdapter {
  constructor(loader) {
    this.loader = loader;
  }
  // Starts the upload process.
  upload() {
    return this.loader.file.then(
      file=>
        new Promise((resolve, reject) => {
          let storageRef = storage.ref();
          let uploadTask = storageRef
            .child(file.name)
            .put(file);
          uploadTask.on(
            firebase.storage.TaskEvent.STATE_CHANGED, // or 'state_changed'
            function(snapshot) {
              // Get task progress, including the number of bytes uploaded and the total number of bytes to be uploaded
              var progress =
                (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
              console.log("Upload is " + progress + "% done");
              switch (snapshot.state) {
                case firebase.storage.TaskState.PAUSED: // or 'paused'
                  console.log("Upload is paused");
                  break;
                case firebase.storage.TaskState.RUNNING: // or 'running'
                  console.log("Upload is running");
                  break;
              }
            },
            function(error) {
              // A full list of error codes is available at
              // https://firebase.google.com/docs/storage/web/handle-errors
              // eslint-disable-next-line default-case
              switch (error.code) {
                case "storage/unauthorized":
                  reject(" User doesn't have permission to access the object");
                  break;

                case "storage/canceled":
                  reject("User canceled the upload");
                  break;

                case "storage/unknown":
                  reject(
                    "Unknown error occurred, inspect error.serverResponse"
                  );
                  break;
              }
            },
            function() {
              // Upload completed successfully, now we can get the download URL
              uploadTask.snapshot.ref
                .getDownloadURL()
                .then(function(downloadURL) {
                  // console.log("File available at", downloadURL);
                  resolve({
                    default: downloadURL
                  });
                });
            }
          );
        })
    );
  }
}


export default function Blog() {
    const postsRef = firestore.collection("posts");
    const editorRef = useRef(null);
    const [ isModalOpen, setModalOpen ] = useState(true);
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const { currentUser } = useAuth();
    const toast = useToast();
    const navigate = useNavigate();

    const handleModalClose = () => {
      setModalOpen(false);
    }

    const handleSubmitBlog = () => {
        const content = editorRef.current.getData();
        const d = new Date();
        const post = {
            createdAt: d.toISOString(),
            authorID: currentUser.uid,
            authorName: currentUser.name,
            content,
            title,
            description,
            type: "blog",
        };
        postsRef
            .add(post)
            .then(() => {
                const toastID = "publish-success";
                if (!toast.isActive(toastID)) {
                    toast({
                        id: toastID,
                        title: "Blog published successfully",
                        status: "success",
                        isClosable: true,
                        position: "top-right",
                    });
                }
                navigate('/');
            })
            .catch((error) => {
                console.error(error);
                const toastID = "publish-fail";
                if (!toast.isActive(toastID)) {
                    toast({
                        id: toastID,
                        title: "Unable publish blog",
                        status: "error",
                        isClosable: true,
                        position: "top-right",
                    });
                }
            });
    };

    if (!currentUser) {
        return <p>Please sign in to write a blog..</p>;
    }

    if (!(currentUser.contentCreator || currentUser.admin)) {
        return (
            <p>You need to be a content creator to be able to write blogs...</p>
        );
    }

    return (
        <>
            <Modal isOpen={isModalOpen} onClose={handleModalClose}>
                <ModalOverlay />
                <ModalContent>
                    <ModalHeader>New Blog</ModalHeader>
                    <ModalBody>
                        <FormControl isRequired>
                            <FormLabel>Title</FormLabel>
                            <Input
                                type="text"
                                placeholder="Blog title"
                                size="lg"
                                onChange={(e) =>
                                    setTitle(e.currentTarget.value)
                                }
                            />
                        </FormControl>
                        <FormControl mt={4} isRequired>
                            <FormLabel>Description</FormLabel>
                            <Textarea
                                placeholder="Here is a sample placeholder"
                                size="lg"
                                resize="horizontal"
                                onChange={(e) =>
                                    setDescription(e.currentTarget.value)
                                }
                            />
                        </FormControl>
                    </ModalBody>

                    <ModalFooter>
                        <Button
                            isDisabled={!title || !description}
                            colorScheme="blue"
                            mr={3}
                            onClick={handleModalClose}
                        >
                            Start editing
                        </Button>
                    </ModalFooter>
                </ModalContent>
            </Modal>

            <div className="main">
                <Button colorScheme="blue" onClick={handleSubmitBlog}>Publish!</Button>
                <Button ml={2} colorScheme="blue" onClick={()=>console.log(editorRef.current.getData())}>Log the content!</Button>
                <CKEditor
                    editor={ClassicEditor}
                    data={`<h1>${title}</h1>`}
                    onReady={(editor) => {
                        editorRef.current = editor;
                        editor.plugins.get("FileRepository").createUploadAdapter = loader => {
                          return new MyUploadAdapter(loader);
                        };
                    }}
                />
            </div>
        </>
    );
}
