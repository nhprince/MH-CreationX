
export const PREFERRED_POSTER_WIDTH = 3546;
export const PREFERRED_POSTER_HEIGHT = 4433;

export const validatePosterSize = (file: File): Promise<{ isValid: boolean; width: number; height: number; dataUrl: string }> => {
  return new Promise((resolve) => {
    const img = new Image();
    const objectUrl = URL.createObjectURL(file);
    img.onload = () => {
      // Logic changed: Always valid now, but we return the dimensions for display
      const isValid = true; 
      resolve({ isValid, width: img.width, height: img.height, dataUrl: img.src });
      URL.revokeObjectURL(objectUrl);
    };
    img.src = objectUrl;
  });
};

export const resizeImageToHQ = (dataUrl: string): Promise<string> => {
  return new Promise((resolve) => {
    const img = new Image();
    img.onload = () => {
      const canvas = document.createElement('canvas');
      canvas.width = PREFERRED_POSTER_WIDTH;
      canvas.height = PREFERRED_POSTER_HEIGHT;
      const ctx = canvas.getContext('2d');
      
      if (ctx) {
        ctx.imageSmoothingEnabled = true;
        ctx.imageSmoothingQuality = 'high';
        ctx.fillStyle = '#000000';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.drawImage(img, 0, 0, PREFERRED_POSTER_WIDTH, PREFERRED_POSTER_HEIGHT);
        resolve(canvas.toDataURL('image/png', 1.0));
      }
    };
    img.src = dataUrl;
  });
};
