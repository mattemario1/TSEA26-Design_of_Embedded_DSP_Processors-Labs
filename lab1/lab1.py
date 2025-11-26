try:
    import numpy as np
    import matplotlib as mpl
    import matplotlib.pyplot as plt
    import scipy
    import scipy.signal
    import os.path
    import sys
except ImportError as e:
    print("**Did you load prog/anaconda3?**\n\n")
    raise e

mpl.use("tkagg")
plt.interactive(True)


def read_hex(filename):
    with open(filename) as f:
        x = np.array([int(line, 16) for line in f.readlines()])
    x[x > 32767] = x[x > 32767] - 65536  # Handle two's complement representation
    return x


def visualize_timedomain(x, y, yq, y_senior, t, h, hq):
    fig, axes = plt.subplots(3, 1)
    axes[0].plot(t, x)
    axes[0].set_xlabel("t [s]")
    axes[0].set_title("ECG + 50 Hz noise")
    axes[0].set_xlim(0, 2)

    axes[1].stem(h, label="Floating-point coefficients")
    axes[1].stem(hq, markerfmt="kx", label="Fixed-point coefficients")
    axes[1].set_title(f"{len(h)}-tap FIR filter")
    axes[1].legend()
    axes[1].set_xlim(0, 30)

    if y_senior.size != 0 and y_senior.size != y.size:
        print(f"{y_senior.shape} {y.shape}")
        raise Exception(
            f"Senior output width does not match expected width. Got {y_senior.size} expected {y.size}"
        )
    relerr1 = scipy.linalg.norm(y - yq) / scipy.linalg.norm(y)
    relerr2 = scipy.linalg.norm(y - y_senior) / scipy.linalg.norm(y)
    relerr3 = scipy.linalg.norm(yq - y_senior) / scipy.linalg.norm(yq)
    axes[2].plot(t, y, label="Floating-point coefficients")
    axes[2].plot(t, yq, label=f"Fixed-point coefficients (rel. error = {relerr1})")
    axes[2].plot(t, y_senior, label=f"Senior (rel. error = {relerr2}, {relerr3})")
    axes[2].set_xlabel("t [s]")
    axes[2].set_title("Restored signal")
    axes[2].legend()
    axes[2].set_xlim(0, 2)

    plt.show()
    return relerr1, relerr2, relerr3


def visualize_freqdomain(x, y, yq, y_senior, h, hq, Fs):
    fig, axes = plt.subplots(3, 1, sharex=True)
    N = len(x)
    xmax = N // 5
    f = np.arange(xmax) * Fs / N
    w = np.linspace(0, xmax / N * 2 * np.pi, 500)
    X = abs(scipy.fft.fft(x))
    _, H = scipy.signal.freqz(h, 1, w)
    _, HQ = scipy.signal.freqz(hq, 1, w)
    Y = abs(scipy.fft.fft(y))
    YQ = abs(scipy.fft.fft(yq))
    YS = abs(scipy.fft.fft(y_senior))
    axes[0].plot(f, 20 * np.log10(X[0:xmax]))
    axes[0].set_xlabel("f [Hz]")
    axes[0].set_ylabel("|X| [dB]")
    axes[0].set_title("Noisy signal")

    axes[1].plot(
        w / (2 * np.pi) * Fs, 20 * np.log10(abs(H)), label="Floating-point coefficients"
    )
    axes[1].plot(
        w / (2 * np.pi) * Fs, 20 * np.log10(abs(HQ)), label="Fixed-point coefficients"
    )
    axes[1].set_xlabel("f [Hz]")
    axes[1].set_ylabel("|H| [dB]")
    axes[1].set_title("Filter")
    axes[1].legend()

    axes[2].plot(f, 20 * np.log10(Y[0:xmax]), label="Floating-point coefficients")
    axes[2].plot(f, 20 * np.log10(YQ[0:xmax]), label="Fixed-point coefficients")
    axes[2].plot(f, 20 * np.log10(YS[0:xmax]), label="Senior")
    axes[2].set_xlabel("f [Hz]")
    axes[2].set_ylabel("|Y| [dB]")
    axes[2].legend()
    axes[2].set_title("Restored signal")
    axes[2].set_xlim(0, 100)

    plt.show()


def lab1():
    # Load noisy input data into x
    x = read_hex("IOS0010")
    Fs = 500  # Sampling frequency
    N = len(x)
    t = np.arange(N) / Fs  # time axis

    # Create a low pass filter with a cut-off frequency of 15 Hz

    order = 32
    # FIXME - Insert the correct value here!
    h = scipy.signal.firwin(order, 15/(Fs/2), window="hamming", pass_zero="lowpass")

    # Alternative filter design method to play around with
    # delta = 0.001
    # h = scipy.signal.remez(order, [0, FIXME, 0.1-delta, 0.1+delta, 0.1+2*delta, 0.5], [1, 0, 0], [10, 100, 1])

    # Quantize the coefficients
    hq = np.around(h * 256) / 256

    # scipy-based filtering
    y = scipy.signal.lfilter(h, 1, x)
    yq = scipy.signal.lfilter(hq, 1, x)

    if os.path.isfile("IOS0011"):
        y_scale = 1
        y_senior = read_hex("IOS0011") / y_scale

    else:
        print("Warning: IOS0011 output from srsim not found!")
        y_senior = np.zeros((len(y), 1))

    relerr1, relerr2, relerr3 = visualize_timedomain(x, y, yq, y_senior, t, h, hq)
    print(
        f"Relative error of fixed-point coefficients compared to floating-point coefficients: {relerr1}"
    )
    print(
        f"Relative error of Senior implementation compared to floating-point coefficients: {relerr2}"
    )
    print(
        f"Relative error of Senior implementation compared to fixed-point coefficients: {relerr3}"
    )
    visualize_freqdomain(x, y, yq, y_senior, h, hq, Fs)
    return h, hq


if __name__ == "__main__":
    h, hq = lab1()

    if not sys.flags.interactive:
        # If we're running non-interactively as `python3 lab1.py` we want to keep
        # plot windows around. However, with block=True ^C does not terminate the
        # program until one of the plot windows is focused. This workaround is
        # stolen from
        # https://gist.github.com/djwbrown/3e24bf4e0c5e9ee156a5?permalink_comment_id=4128738#gistcomment-4128738
        import signal

        signal.signal(signal.SIGINT, signal.SIG_DFL)

        plt.show(block=True)


    scaling = 8

    x = np.asarray(hq, dtype=float)
    print(hq)
    q = np.round(h * 32768 * scaling).astype(int)
    # q = np.clip(q, -32768, 32767)
    # q - np.where(q < 0, q + 65536, q)

    # q = q * scaling

    for val in q:
        print(f".dw 0x{val:04x}")