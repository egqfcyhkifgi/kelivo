# Build X API Configuration

## Overview
Build X connects to a single AI model via API. The application is configured to work with your custom model endpoint.

## API Configuration

### Environment Variables
The application uses a `.env` file to configure the API connection. Create or edit the `.env` file in the root directory:

```env
# API Configuration
API_URL=https://premiere-geographic-telling-call.trycloudflare.com
MODEL_NAME=Build X
API_TIMEOUT=30000
MAX_TOKENS=4096
```

### Configuration Parameters

- **API_URL**: The base URL of your model API endpoint
- **MODEL_NAME**: Display name for the model (should be "Build X")
- **API_TIMEOUT**: Request timeout in milliseconds (default: 30000)
- **MAX_TOKENS**: Maximum tokens for model responses (default: 4096)

## Changing the API Endpoint

To change the API endpoint:

1. Open the `.env` file in the root directory
2. Update the `API_URL` value with your new endpoint
3. Restart the application

Example:
```env
API_URL=https://your-new-endpoint.com
```

## API Requirements

Your API endpoint should:
- Accept POST requests to `/v1/chat/completions` (OpenAI-compatible format)
- Support streaming responses
- Handle authentication if required
- Return responses in OpenAI chat completion format

## Testing the Connection

The application will automatically test the API connection on startup. If the connection fails:
1. Check that your API endpoint is accessible
2. Verify the URL format is correct
3. Ensure your model server is running
4. Check network connectivity

## Troubleshooting

### Common Issues:
- **Connection timeout**: Increase `API_TIMEOUT` value
- **Invalid response**: Ensure API returns OpenAI-compatible format
- **Network errors**: Check firewall and network settings

### Debug Mode:
Enable debug logging in the app settings to see detailed API communication logs.

## Security Notes

- Keep your `.env` file secure and don't commit it to version control
- Use HTTPS endpoints for production
- Consider implementing API authentication if needed