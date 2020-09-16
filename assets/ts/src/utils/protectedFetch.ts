export const protectedFetch = async <T>(
  input: RequestInfo,
  init?: RequestInit | undefined
): Promise<T | undefined> => {
  const response = await fetch(input, {
    ...init,
    headers: {
      'Content-Type': 'application/json'
    }
  });
  if (response.status === 401) {
    window.location.replace('/users/log_in');
  } else {
    if (response.status >= 400) {
      const { errors } = await response.json();
      throw errors;
    }
    const { data } = await response.json();
    return data;
  }
};
