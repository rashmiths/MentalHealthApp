import React, { useState } from "react";
import {
    Flex,
    Box,
    Heading,
    FormLabel,
    Input,
    Button,
    FormControl,
    useToast,
    Text,
    HStack,
    Link,
} from "@chakra-ui/react";
import { FcGoogle } from "react-icons/fc";
import { Link as RouterLink, useNavigate } from "react-router-dom";
import { useAuth } from "../../Context/AuthContext";

export default function SignIn() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [submitting, setSubmitting] = useState(false);
    const { loginWithEmailAndPassword, signInWithGoogle } = useAuth();
    const toast = useToast();
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            setSubmitting(true);
            await loginWithEmailAndPassword(email, password);
        } catch (error) {
            const toastID = "signin-fail";
            if (!toast.isActive(toastID)) {
                toast({
                    id: toastID,
                    title: "Unable to sign in",
                    description: "Please check the email and password",
                    status: "error",
                    isClosable: true,
                    position: "top-right",
                });
            }
        }
        setSubmitting(false);
        navigate('/');
    };

    const handleSignInWithGoogle = async() => {
        setSubmitting(true);
        await signInWithGoogle();
        setSubmitting(false);
        navigate('/');
    }

    return (
        <Flex width="full" align="center" justifyContent="center">
            <Box
                p={8}
                maxWidth="500px"
                borderWidth={1}
                borderRadius={8}
                boxShadow="lg"
            >
                <Box textAlign="center">
                    <Heading>Login</Heading>
                </Box>
                <Box my={4} textAlign="left">
                    <form onSubmit={handleSubmit}>
                        <FormControl isRequired>
                            <FormLabel>Email</FormLabel>
                            <Input
                                type="email"
                                placeholder="your@example.com"
                                size="lg"
                                onChange={(e) =>
                                    setEmail(e.currentTarget.value)
                                }
                            />
                        </FormControl>
                        <FormControl mt={4} isRequired>
                            <FormLabel>Password</FormLabel>
                            <Input
                                type="password"
                                placeholder="*******"
                                size="lg"
                                onChange={(e) =>
                                    setPassword(e.currentTarget.value)
                                }
                            />
                        </FormControl>
                        <Button
                            isLoading={submitting}
                            loadingText="Submitting"
                            width="full"
                            mt={4}
                            type="submit"
                        >
                            Sign In
                        </Button>
                    </form>
                    <Box textAlign="center" mt="4" mb="2">
                        <Text color="gray.500">Or, sign in with</Text>
                    </Box>
                    <HStack>
                        <Button width="full" leftIcon={<FcGoogle />} onClick={handleSignInWithGoogle}>
                            Google
                        </Button>
                    </HStack>
                    <Box textAlign="center" mt="5">
                        <Text color="gray.500">
                            Don't have an account?{" "}
                            <Link as={RouterLink} to="/sign_up" color="blue.400">
                                Register
                            </Link>
                        </Text>
                    </Box>
                </Box>
            </Box>
        </Flex>
    );
}
