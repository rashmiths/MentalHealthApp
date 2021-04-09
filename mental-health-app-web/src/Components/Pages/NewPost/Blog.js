import { useRef, useState, useCallback } from "react";
import firebase from "firebase/app";
import firestore, { storage } from "../../../firebaseConfig";
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
    Box,
    Text,
    Image,
    Spinner,
    Select,
} from "@chakra-ui/react";
import { useNavigate } from "react-router";
import "./editor.scss";
import { useDropzone } from "react-dropzone";

class MyUploadAdapter {
    constructor(loader) {
        this.loader = loader;
    }
    // Starts the upload process.
    upload() {
        return this.loader.file.then(
            (file) =>
                new Promise((resolve, reject) => {
                    let storageRef = storage.ref();
                    let uploadTask = storageRef.child(file.name).put(file);
                    uploadTask.on(
                        firebase.storage.TaskEvent.STATE_CHANGED, // or 'state_changed'
                        function (snapshot) {
                            // Get task progress, including the number of bytes uploaded and the total number of bytes to be uploaded
                            var progress =
                                (snapshot.bytesTransferred /
                                    snapshot.totalBytes) *
                                100;
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
                        function (error) {
                            // A full list of error codes is available at
                            // https://firebase.google.com/docs/storage/web/handle-errors
                            // eslint-disable-next-line default-case
                            switch (error.code) {
                                case "storage/unauthorized":
                                    reject(
                                        " User doesn't have permission to access the object"
                                    );
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
                        function () {
                            // Upload completed successfully, now we can get the download URL
                            uploadTask.snapshot.ref
                                .getDownloadURL()
                                .then(function (downloadURL) {
                                    // console.log("File available at", downloadURL);
                                    resolve({
                                        default: downloadURL,
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
    const [isModalOpen, setModalOpen] = useState(true);
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const [display_image, setDisplay_image] = useState(null);
    const display_image_load_state = useRef(0);
    const [tag, setTag] = useState("");
    const { currentUser } = useAuth();
    const toast = useToast();
    const navigate = useNavigate();
    const onDrop = useCallback((acceptedFiles) => {
        const file = acceptedFiles[0];
        let storageRef = storage.ref();
        display_image_load_state.current = 1;
        let uploadTask = storageRef.child(file.name).put(file);
        uploadTask.on(
            firebase.storage.TaskEvent.STATE_CHANGED, // or 'state_changed'
            function (snapshot) {
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
            function (error) {
                // A full list of error codes is available at
                // https://firebase.google.com/docs/storage/web/handle-errors
                // eslint-disable-next-line default-case
                switch (error.code) {
                    case "storage/unauthorized":
                        console.error(
                            " User doesn't have permission to access the object"
                        );
                        break;

                    case "storage/canceled":
                        console.error("User canceled the upload");
                        break;

                    case "storage/unknown":
                        console.error(
                            "Unknown error occurred, inspect error.serverResponse"
                        );
                        break;
                    default: {
                        const toastID = "img-upload-fail";
                        display_image_load_state=0;
                        if (!toast.isActive(toastID)) {
                            toast({
                                id: toastID,
                                title: "Unable to upload image",
                                description:
                                    "Please check the console logs for more details",
                                status: "error",
                                isClosable: true,
                                position: "top-right",
                            });
                        }
                    }
                }
            },
            function () {
                // Upload completed successfully, now we can get the download URL
                uploadTask.snapshot.ref
                    .getDownloadURL()
                    .then(function (downloadURL) {
                        // console.log("File available at", downloadURL);
                        display_image_load_state = 2;
                        setDisplay_image(downloadURL);
                    });
            }
        );
    }, []);

    const { getRootProps, getInputProps } = useDropzone({ onDrop });

    const handleModalClose = () => {
        setModalOpen(false);
    };

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
            display_image,
            tag,
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
                navigate("/");
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
        return <Text>Please sign in to write a blog..</Text>;
    }

    if (!(currentUser.contentCreator || currentUser.admin)) {
        return (
            <Text>
                You need to be a content creator to be able to write blogs...
            </Text>
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

                        <FormControl isRequired my={4}>
                            <FormLabel>Display Image</FormLabel>
                            {display_image_load_state === 0 && (
                                <Box
                                    {...getRootProps()}
                                    py={10}
                                    px={3}
                                    border={"dashed"}
                                    borderColor="gray.300"
                                >
                                    <input {...getInputProps()} />
                                    <Text color="gray.400">
                                        Drag 'n' drop some image here, or click
                                        to select file
                                    </Text>
                                </Box>
                            )}
                            {display_image_load_state === 1 && (
                                <Spinner color="gray.400" />
                            )}
                            {display_image_load_state === 2 && (
                                <Image
                                    borderRadius="full"
                                    boxSize="250px"
                                    src={display_image}
                                    alt="Display Image"
                                    mx="auto"
                                />
                            )}
                        </FormControl>

                        <FormControl my={4} isRequired>
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

                        <FormControl mt={4} isRequired>
                            <FormLabel>Tag</FormLabel>
                            <Select
                                value={tag}
                                onChange={(e) => setTag(e.target.value)}
                                placeholder="Select option"
                            >
                                <option value="option1">Exercise</option>
                                <option value="option2">Meditation</option>
                                <option value="option3">General</option>
                            </Select>
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
                <Button colorScheme="blue" onClick={handleSubmitBlog}>
                    Publish!
                </Button>
                <Button
                    ml={2}
                    colorScheme="blue"
                    onClick={() => console.log(editorRef.current.getData())}
                >
                    Log the content!
                </Button>
                <CKEditor
                    editor={ClassicEditor}
                    data={`<h1>${title}</h1>`}
                    onReady={(editor) => {
                        editorRef.current = editor;
                        editor.plugins.get(
                            "FileRepository"
                        ).createUploadAdapter = (loader) => {
                            return new MyUploadAdapter(loader);
                        };
                    }}
                />
            </div>
        </>
    );
}
