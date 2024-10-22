package apperrors

type MyAppError struct {
	ErrCode
	Message string
	Err     error `json:"-"`
}

func (myErr *MyAppError) Error() string {
	return myErr.Err.Error()
}

// error.Is/ error.As を使えるように
func (myErr *MyAppError) Unwrap() error {
	return myErr.Err
}
